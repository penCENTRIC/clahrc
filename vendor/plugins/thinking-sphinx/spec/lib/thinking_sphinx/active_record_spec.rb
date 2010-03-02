require 'spec/spec_helper'

describe ThinkingSphinx::ActiveRecord do
  describe '.define_index' do
    before :each do
      module ::TestModule
        class TestModel < ActiveRecord::Base; end
      end
      
      TestModule::TestModel.stub!(
        :before_save    => true,
        :after_commit   => true,
        :after_destroy  => true
      )
      
      @index = ThinkingSphinx::Index.new(TestModule::TestModel)
      @index.stub!(:delta? => false)
      ThinkingSphinx::Index::Builder.stub!(:generate => @index)
    end
    
    after :each do
      # Remove the class so we can redefine it
      TestModule.send(:remove_const, :TestModel)
      
      ThinkingSphinx.indexed_models.delete "TestModule::TestModel"
    end
    
    it "should do nothing if indexes are disabled" do
      ThinkingSphinx.define_indexes = false
      ThinkingSphinx::Index.should_not_receive(:new)
      
      TestModule::TestModel.define_index {}
      
      ThinkingSphinx.define_indexes = true
    end
    
    it "should add a new index to the model" do
      TestModule::TestModel.define_index {}
      
      TestModule::TestModel.sphinx_indexes.length.should == 1
    end
    
    it "should add to ThinkingSphinx.indexed_models if the model doesn't already exist in the array" do
      TestModule::TestModel.define_index do; end
      
      ThinkingSphinx.indexed_models.should include("TestModule::TestModel")
    end
    
    it "shouldn't add to ThinkingSphinx.indexed_models if the model already exists in the array" do
      TestModule::TestModel.define_index do; end
      
      ThinkingSphinx.indexed_models.select { |model|
        model == "TestModule::TestModel"
      }.length.should == 1
      
      TestModule::TestModel.define_index do; end
      
      ThinkingSphinx.indexed_models.select { |model|
        model == "TestModule::TestModel"
      }.length.should == 1
    end
    
    it "should add before_save and after_commit hooks to the model if delta indexing is enabled" do
      @index.stub!(:delta? => true)
      TestModule::TestModel.should_receive(:before_save).with(:toggle_delta)
      TestModule::TestModel.should_receive(:after_commit).with(:index_delta)
      
      TestModule::TestModel.define_index do; end
    end
    
    it "should not add before_save and after_commit hooks to the model if delta indexing is disabled" do
      TestModule::TestModel.should_not_receive(:before_save).with(:toggle_delta)
      TestModule::TestModel.should_not_receive(:after_commit).with(:index_delta)
      
      TestModule::TestModel.define_index do; end
    end
    
    it "should add an after_destroy hook with delta indexing enabled" do
      @index.stub!(:delta? => true)
      TestModule::TestModel.should_receive(:after_destroy).with(:toggle_deleted)
      
      TestModule::TestModel.define_index do; end
    end
    
    it "should add an after_destroy hook with delta indexing disabled" do
      TestModule::TestModel.should_receive(:after_destroy).with(:toggle_deleted)
      
      TestModule::TestModel.define_index do; end
    end
    
    it "should return the new index" do
      TestModule::TestModel.define_index.should == @index
    end
    
    it "should die quietly if there is a database error" do
      ThinkingSphinx::Index::Builder.stub(:generate) { raise Mysql::Error }
      
      lambda {
        TestModule::TestModel.define_index
      }.should_not raise_error
    end
    
    it "should die noisily if there is a non-database error" do
      ThinkingSphinx::Index::Builder.stub(:generate) { raise StandardError }
      
      lambda {
        TestModule::TestModel.define_index
      }.should raise_error
    end
  end

  describe "index methods" do
    before(:all) do
      @person = Person.find(:first)
    end

    describe "in_both_indexes?" do
      it "should return true if in core and delta indexes" do
        @person.should_receive(:in_core_index?).and_return(true)
        @person.should_receive(:in_delta_index?).and_return(true)
        @person.in_both_indexes?.should be_true
      end
      
      it "should return false if in one index and not the other" do
        @person.should_receive(:in_core_index?).and_return(true)
        @person.should_receive(:in_delta_index?).and_return(false)
        @person.in_both_indexes?.should be_false
      end
    end

    describe "in_core_index?" do
      it "should call in_index? with core" do
        @person.should_receive(:in_index?).with('core')
        @person.in_core_index?
      end
    end

    describe "in_delta_index?" do
      it "should call in_index? with delta" do
        @person.should_receive(:in_index?).with('delta')
        @person.in_delta_index?
      end
    end

    describe "in_index?" do
      it "should return true if in the specified index" do
        @person.should_receive(:sphinx_document_id).and_return(1)
        @person.should_receive(:sphinx_index_name).and_return('person_core')
        Person.should_receive(:search_for_id).with(1, 'person_core').and_return(true)
      
        @person.in_index?('core').should be_true
      end
    end
  end

  describe '.source_of_sphinx_index' do
    it "should return self if model defines an index" do
      Person.source_of_sphinx_index.should == Person
    end

    it "should return the parent if model inherits an index" do
      Admin::Person.source_of_sphinx_index.should == Person
    end
  end
  
  describe '.to_crc32' do
    it "should return an integer" do
      Person.to_crc32.should be_a_kind_of(Integer)
    end
  end
    
  describe '.to_crc32s' do
    it "should return an array" do
      Person.to_crc32s.should be_a_kind_of(Array)
    end
  end
    
  describe "toggle_deleted method" do
    before :each do
      ThinkingSphinx.stub!(:sphinx_running? => true)
      
      @configuration = ThinkingSphinx::Configuration.instance
      @configuration.stub!(
        :address  => "an address",
        :port     => 123
      )
      @client = Riddle::Client.new
      @client.stub!(:update => true)
      @person = Person.find(:first)
      
      Riddle::Client.stub!(:new => @client)
      Person.sphinx_indexes.each { |index| index.stub!(:delta? => false) }
      @person.stub!(:in_core_index? => true)
    end
    
    it "should create a client using the Configuration's address and port" do
      Riddle::Client.should_receive(:new).with(
        @configuration.address, @configuration.port
      )
      
      @person.toggle_deleted
    end
    
    it "should update the core index's deleted flag if in core index" do
      @client.should_receive(:update).with(
        "person_core", ["sphinx_deleted"], {@person.sphinx_document_id => 1}
      )
      
      @person.toggle_deleted
    end
    
    it "shouldn't update the core index's deleted flag if the record isn't in it" do
      @person.stub!(:in_core_index? => false)
      @client.should_not_receive(:update).with(
        "person_core", ["sphinx_deleted"], {@person.sphinx_document_id => 1}
      )
      
      @person.toggle_deleted
    end
    
    it "shouldn't attempt to update the deleted flag if sphinx isn't running" do
      ThinkingSphinx.stub!(:sphinx_running? => false)
      @client.should_not_receive(:update)
      @person.should_not_receive(:in_core_index?)
      
      @person.toggle_deleted
    end
    
    it "should update the delta index's deleted flag if delta indexes are enabled and the instance's delta is true" do
      ThinkingSphinx.deltas_enabled = true
      Person.sphinx_indexes.each { |index| index.stub!(:delta? => true) }
      @person.delta = true
      @client.should_receive(:update).with(
        "person_delta", ["sphinx_deleted"], {@person.sphinx_document_id => 1}
      )
      
      @person.toggle_deleted
    end
    
    it "should not update the delta index's deleted flag if delta indexes are enabled and the instance's delta is false" do
      ThinkingSphinx.deltas_enabled = true
      Person.sphinx_indexes.each { |index| index.stub!(:delta? => true) }
      @person.delta = false
      @client.should_not_receive(:update).with(
        "person_delta", ["sphinx_deleted"], {@person.sphinx_document_id => 1}
      )
      
      @person.toggle_deleted
    end
    
    it "should not update the delta index's deleted flag if delta indexes are enabled and the instance's delta is equivalent to false" do
      ThinkingSphinx.deltas_enabled = true
      Person.sphinx_indexes.each { |index| index.stub!(:delta? => true) }
      @person.delta = 0
      @client.should_not_receive(:update).with(
        "person_delta", ["sphinx_deleted"], {@person.sphinx_document_id => 1}
      )

      @person.toggle_deleted
    end

    it "shouldn't update the delta index if delta indexes are disabled" do
      ThinkingSphinx.deltas_enabled = true
      @client.should_not_receive(:update).with(
        "person_delta", ["sphinx_deleted"], {@person.sphinx_document_id => 1}
      )
      
      @person.toggle_deleted
    end
    
    it "should not update the delta index if delta indexing is disabled" do
      ThinkingSphinx.deltas_enabled = false
      Person.sphinx_indexes.each { |index| index.stub!(:delta? => true) }
      @person.delta = true
      @client.should_not_receive(:update).with(
        "person_delta", ["sphinx_deleted"], {@person.sphinx_document_id => 1}
      )
      
      @person.toggle_deleted
    end
    
    it "should not update either index if updates are disabled" do
      ThinkingSphinx.updates_enabled = false
      ThinkingSphinx.deltas_enabled  = true
      Person.sphinx_indexes.each { |index| index.stub!(:delta? => true) }
      @person.delta = true
      @client.should_not_receive(:update)
      
      @person.toggle_deleted
    end
  end

  describe "sphinx_indexes in the inheritance chain (STI)" do
    it "should hand defined indexes on a class down to its child classes" do
      Child.sphinx_indexes.should include(*Person.sphinx_indexes)
    end

    it "should allow associations to other STI models" do
      source = Child.sphinx_indexes.last.sources.first
      sql = source.to_riddle_for_core(0, 0).sql_query
      sql.gsub!('$start', '0').gsub!('$end', '100')
      lambda {
        Child.connection.execute(sql)
      }.should_not raise_error(ActiveRecord::StatementInvalid)
    end
  end
  
  it "should return the sphinx document id as expected" do
    person      = Person.find(:first)
    model_count = ThinkingSphinx.indexed_models.length
    offset      = ThinkingSphinx.indexed_models.index("Person")
    
    (person.id * model_count + offset).should == person.sphinx_document_id
    
    alpha       = Alpha.find(:first)
    offset      = ThinkingSphinx.indexed_models.index("Alpha")
    
    (alpha.id * model_count + offset).should == alpha.sphinx_document_id
    
    beta        = Beta.find(:first)
    offset      = ThinkingSphinx.indexed_models.index("Beta")
    
    (beta.id * model_count + offset).should == beta.sphinx_document_id
  end
  
  describe '#primary_key_for_sphinx' do
    before :each do
      @person = Person.find(:first)
    end
    
    after :each do
      Person.set_sphinx_primary_key nil
    end
    
    it "should return the id by default" do
      @person.primary_key_for_sphinx.should == @person.id
    end
    
    it "should use the sphinx primary key to determine the value" do
      Person.set_sphinx_primary_key :first_name
      @person.primary_key_for_sphinx.should == @person.first_name
    end
    
    it "should not use accessor methods but the attributes hash" do
      id = @person.id
      @person.stub!(:id => 'unique_hash')
      @person.primary_key_for_sphinx.should == id
    end
  end
  
  describe '.sphinx_index_names' do
    it "should return the core index" do
      Alpha.sphinx_index_names.should == ['alpha_core']
    end
    
    it "should return the delta index if enabled" do
      Beta.sphinx_index_names.should == ['beta_core', 'beta_delta']
    end
    
    it "should return the superclass with an index definition" do
      Parent.sphinx_index_names.should == ['person_core', 'person_delta']
    end
  end
end
