require 'rails_helper'
require 'spec_helper'

class Group
    attr_accessor :name, :description, :fun, :date_of_start, :date_of_end, :hours
RSpec.describe Group  do
    before do 
        @group=Group.new("Gr","sjhd",true,"2022-08-07","2022-08-10",20)
    end
        context 'name' do
            it 'should have a name attribute' do
                expect(@group.name).to eq("Gr")
            end
                
        end
    end