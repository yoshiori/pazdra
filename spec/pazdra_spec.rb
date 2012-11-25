# -*- coding: utf-8 -*-
require 'spec_helper'
require 'timecop'

xml_11_19 = <<EOF
<?xml version="1.0" encoding="utf-8"?>
<root><item><group>A</group><hour>10&lt;br&gt;15</hour><day>11/19</day><type>meta</type></item><item><group>B</group><hour>9&lt;br&gt;14</hour><day>11/19</day><type>meta</type></item><item><group>C</group><hour>8&lt;br&gt;13</hour><day>11/19</day><type>meta</type></item><item><group>D</group><hour>12&lt;br&gt;17</hour><day>11/19</day><type>meta</type></item><item><group>E</group><hour>11&lt;br&gt;16</hour><day>11/19</day><type>meta</type></item></root>
EOF

xml_11_21 =<<EOF
<?xml version="1.0" encoding="utf-8"?>
<root><item><group>A</group><hour>&lt;p class="eme"&gt;11&lt;/p&gt;&lt;p class="ruby"&gt;16&lt;/p&gt;&lt;p class="safa"&gt;21&lt;/p&gt;</hour><day>11/21</day><type>plu</type></item><item><group>D</group><hour>&lt;p class="eme"&gt;8&lt;/p&gt;&lt;p class="ruby"&gt;13&lt;/p&gt;&lt;p class="safa"&gt;18&lt;/p&gt;</hour><day>11/21</day><type>plu</type></item><item><group>B</group><hour>&lt;p class="ruby"&gt;10&lt;/p&gt;&lt;p class="safa"&gt;15&lt;/p&gt;&lt;p class="eme"&gt;20&lt;/p&gt;</hour><day>11/21</day><type>plu</type></item><item><group>E</group><hour>&lt;p class="ruby"&gt;12&lt;/p&gt;&lt;p class="safa"&gt;17&lt;/p&gt;&lt;p class="eme"&gt;22&lt;/p&gt;</hour><day>11/21</day><type>plu</type></item><item><group>C</group><hour>&lt;p class="safa"&gt;9&lt;/p&gt;&lt;p class="eme"&gt;14&lt;/p&gt;&lt;p class="ruby"&gt;19&lt;/p&gt;</hour><day>11/21</day><type>plu</type></item></root>
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
    pazdra.stub(:raw_xml).and_return(xml)
    pazdra
  end

  context "11/19" do
    let(:xml) do
      xml_11_19
    end

    before do
      Timecop.travel(Date.new(2012,11,19))
    end

    it { should == {:day => "11/19", :type => 'meta', :hours => ["11","16"]} }

    after do
      Timecop.return
    end
  end

  context "11/21" do
    let(:xml) do
      xml_11_21
    end

    before do
      Timecop.travel(Date.new(2012,11,21))
    end

    it { should == {:day => "11/21", :type => 'plu', :hours => ["12", "17", "22"]} }

    after do
      Timecop.return
    end
  end

  context "not 11/19" do
    let(:xml) do
      xml_11_19
    end

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
