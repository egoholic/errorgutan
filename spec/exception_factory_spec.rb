RSpec.describe Errorgutan::ExceptionFactory do
  let(:exception_class) { StandardError }
  let(:message) { "some exception" }
  let :backtrace do
    ["from /blah_blah_blah.rb:18:in `block (5 levels) in <top (required)>"]
  end
  let(:original_exception) { FakeException.new(message, backtrace) }

  describe "class" do
    subject { described_class }

    describe ".new" do
      context "when correct args" do
        it "doesn't raise an exception" do
          expect { subject.new(exception_class, original_exception) }.not_to raise_error
        end
      end

      context "when wrong args" do
        it "raises ArgumentError" do
          expect { subject.new nil, nil }.to raise_error(ArgumentError)
          expect { subject.new }.to raise_error(ArgumentError)
          expect { subject.new exception_class, nil }.to raise_error(ArgumentError)
          expect { subject.new nil, original_exception }.to raise_error(ArgumentError)
          expect { subject.new Class.new, original_exception }.to raise_error(ArgumentError)
          expect { subject.new exception_class, true }.to raise_error(ArgumentError)
          expect { subject.new true, true }.to raise_error(ArgumentError)
        end
      end
    end

    describe ".build" do
      context "when correct args" do
        it "returns a correct exception" do
          exception = subject.build(exception_class, original_exception)

          expect(exception).not_to be original_exception 
          expect(exception).to be_a exception_class
          expect(exception.message).to eq message
          expect(exception.backtrace).to eq backtrace
        end
      end

      context "when wrong args" do
        context "when `exception_class` and `original_exception` are `nil` or not provided" do
          it "raises ArgumentError" do
            expect { subject.build nil, nil }.to raise_error(ArgumentError)
            expect { subject.build }.to raise_error(ArgumentError)
            expect { subject.build nil, original_exception }.to raise_error(ArgumentError)
            expect { subject.build exception_class, nil }.to raise_error(ArgumentError)
            expect { subject.build exception_class }.to raise_error(ArgumentError)
            expect { subject.build Class.new, original_exception }.to raise_error(ArgumentError)
            expect { subject.build exception_class, true }.to raise_error(ArgumentError)
          end
        end
      end
    end
  end

  describe "instance" do
    subject { described_class.new(exception_class, original_exception) }

    describe "#exception" do
      it "returns a correct exception" do
        exception = subject.exception

        expect(exception).not_to be             original_exception
        expect(exception).to     be_instance_of exception_class

        expect(exception.message).to   be_a String
        expect(exception.message).to   eq original_exception.message
        expect(exception.backtrace).to eq original_exception.backtrace
      end
    end
  end
end
