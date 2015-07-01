RSpec.describe Errorgutan::ExceptionsHandlers do
  let(:exception_class) { FakeException }
  let(:handler) { Errorgutan::Handler.new { |e| "handler" } }
  let(:default_handler) { Errorgutan::Handler.new { |e| "default_handler" } }

  describe "class" do
    subject { described_class }

    describe ".new" do
      context "when correct arguments" do
        it "doesn't raise an exception" do
          expect { subject.new(default: default_handler) }.not_to raise_error
        end
      end

      context "when wrong arguments" do
        it "raises ArgumentError" do
          expect { subject.new default: nil }.to raise_error(ArgumentError)
          expect { subject.new }.to raise_error(ArgumentError)
          expect { subject.new default: Class.new }.to raise_error(ArgumentError)
        end
      end
    end
  end

  describe "instance" do
    subject { described_class.new default: default_handler }

    describe "#handle" do
      context "when correct arguments" do
        it "assigns a handler for given exceptions" do
          expect { subject.handle exception_class, with: handler }
            .to change { subject[exception_class] }
              .from(default_handler)
              .to(handler)
        end
      end

      context "when wrong arguments" do
        it "raises ArgumentError" do
          expect { subject.handle(nil, with: nil) }.to raise_error(ArgumentError)
          expect { subject.handle}.to raise_error(ArgumentError)
          expect { subject.handle(nil, with: handler) }.to raise_error(ArgumentError)
          expect { subject.handle(with: handler) }.to raise_error(ArgumentError)
          expect { subject.handle(exception_class, with: nil) }.to raise_error(ArgumentError)
          expect { subject.handle(exception_class) }.to raise_error(ArgumentError)
          expect { subject.handle Class.new, with: Class.new }.to raise_error(ArgumentError)
          expect { subject.handle exception_class, with: Class.new }.to raise_error(ArgumentError)
          expect { subject.handle Class.new, with: handler }.to raise_error(ArgumentError)
          expect { subject.handle exception_class, Class.new, with: handler }.to raise_error(ArgumentError)
          expect { subject.handle exception_class, nil, with: handler }.to raise_error(ArgumentError)
        end
      end
    end

    describe "#[]" do
      context "when correct arguments" do
        context "when has defined handler" do
          it "returns handler" do
            subject.handle(exception_class, with: handler)

            expect(subject[exception_class]).to eq handler
          end
        end

        context "when has no defined handler" do
          it "returns default handler" do
            expect(subject[exception_class]).to eq default_handler
          end
        end
      end

      context "when wrong arguments" do
        it "raises ArgumentError" do
          expect { subject[] }.to raise_error(ArgumentError)
          expect { subject[nil] }.to raise_error(ArgumentError)
          expect { subject[Class.new] }.to raise_error(ArgumentError)
        end
      end
    end
  end
end
