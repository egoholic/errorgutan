RSpec.describe Errorgutan::Handler do
  let(:exception) { FakeException.new("some exception", [""]) }
  let(:block) { ->(e) { "#{e.class} Handled!" } }

  describe "class" do
    subject { described_class }

    describe ".new" do
      context "when correct arguments" do
        it "returns it's instance" do
          expect(subject.new &block).to be_a described_class
        end
      end

      context "when wrong arguments" do
        it "raise ArgumentError" do
          expect { subject.new }.to raise_error(ArgumentError)
        end
      end
    end
  end

  describe "instance" do
    subject { described_class.new(&block) }

    describe "#handle" do
      context "when correct arguments" do
        it "handles the exception" do
          expect(subject.handle exception).to eq "FakeException Handled!"
        end
      end

      context "when wrong arguments" do
        it "raises ArgumentError" do
          expect { subject.handle nil }.to raise_error(ArgumentError)
          expect { subject.handle }.to raise_error(ArgumentError)
          expect { subject.handle true }.to raise_error(ArgumentError)
        end
      end
    end
  end
end
