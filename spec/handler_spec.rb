RSpec.describe Errorgutan::Handler do
  let(:exception) { FakeException.new("some exception", [""]) }
  let(:block) { ->(e) { "Handled!" } }

  describe "class" do
    subject { described_class }

    describe ".new" do
      context "when correct arguments" do
        it "returns it's instance" do
          expect(subject.new &block).to be_a described_class
        end
      end

      context "when wrong arguments" do
        context "when `handler` block is not given" do
          it "raise an exception" do
            expect { subject.new }.to raise_error(ArgumentError)
          end
        end
      end
    end
  end

  describe "instance" do
    subject { described_class.new(&block) }

    describe "#handle" do
      context "when correct arguments" do
        it "handles the exception" do
          expect(subject.handle exception).to eq "Handled!"
        end
      end

      context "when wrong arguments" do
        context "when `exception` is not Exception or not given" do
          it "raises an exception" do
            expect { subject.handle nil }.to raise_error(ArgumentError)
            expect { subject.handle }.to raise_error(ArgumentError)
          end
        end
      end
    end
  end
end
