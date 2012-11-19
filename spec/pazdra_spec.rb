# -*- coding: utf-8 -*-
require 'spec_helper'
require 'timecop'

xml_11_19 = <<EOF
<?xml version="1.0" encoding="utf-8"?>
<root><item><group>A</group><hour>10&lt;br&gt;15</hour><day>11/19</day><type>meta</type></item><item><group>B</group><hour>9&lt;br&gt;14</hour><day>11/19</day><type>meta</type></item><item><group>C</group><hour>8&lt;br&gt;13</hour><day>11/19</day><type>meta</type></item><item><group>D</group><hour>12&lt;br&gt;17</hour><day>11/19</day><type>meta</type></item><item><group>E</group><hour>11&lt;br&gt;16</hour><day>11/19</day><type>meta</type></item></root>
EOF

describe "#guerrillas" do
  subject do
    pazdra.guerrillas
  end

  let(:pazdra) do
    pazdra = Pazdra.new(1)
    pazdra.stub(:group).and_return('E')
    pazdra.stub(:raw_xml).and_return(xml_11_19)
    pazdra
  end

  context "11/19" do
    it { should_not be_empty }
  end
end

describe "#guerrilla" do
  subject do
    pazdra.guerrilla
  end

  let(:pazdra) do
    pazdra = Pazdra.new(1)
    pazdra.stub(:group).and_return('E')
    pazdra.stub(:raw_xml).and_return(xml_11_19)
    pazdra
  end

  context "11/19" do
    before do
      Timecop.travel(Date.new(2012,11,19))
    end

    it { should == {:day => "11/19", :type => 'meta', :hours => ["11","16"]} }

    after do
      Timecop.return
    end
  end

  context "not 11/19" do

    before do
      Timecop.travel(Date.new(2012,11,20))
    end

    it { should be_nil }

    after do
      Timecop.return
    end
  end
end

describe "#group" do
  subject do
    pazdra.group
  end

  let(:pazdra) do
    pazdra = Pazdra.new(id)
    pazdra
  end

  context "id is 111111111111" do
    let(:id) do
      111111111111
    end

    it{ should == 'B' }
  end

  context "id is 110111111111" do
    let(:id) do
      110111111111
    end

    it{ should == 'A' }
  end

  context "id is invalid" do
    let(:id) do
      1
    end

    it{ should == nil }
  end
end
