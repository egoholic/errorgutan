RSpec.describe Errorgutan::ExceptionsHandlers do
  let(:exception) { FakeException }
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
        context "when `default:` hanler is `nil` or not provided" do
          it "raises an exception" do
            expect { subject.new(default: nil) }.to raise_error(ArgumentError)
            expect { subject.new }.to raise_error(ArgumentError)
          end
        end
      end
    end
  end

  describe "instance" do
    subject { described_class.new default: default_handler }

    describe "#handle" do
      context "when correct arguments" do
        it "assigns a handler for given exceptions" do
          expect { subject.handle exception, with: handler }
            .to change { subject[exception] }
              .from(default_handler)
              .to(handler)
        end
      end

      context "when wrong arguments" do
        context "when `exceptions` and binding `to:` are `nil` or not given" do
          it "raises an exception" do
            expect { subject.handle(nil, with: nil) }.to raise_error(ArgumentError)
            expect { subject.handle}.to raise_error(ArgumentError)
          end
        end

        context "when `exceptions` is `nil` or not given" do
          it "raises an exception" do
            expect { subject.handle(nil, with: handler) }.to raise_error(ArgumentError)
            expect { subject.handle(with: handler) }.to raise_error(ArgumentError)
          end
        end

        context "when binding `to:` is nil or not given" do
          it "raises an exception" do
            expect { subject.handle(exception, with: nil) }.to raise_error(ArgumentError)
            expect { subject.handle(exception) }.to raise_error(ArgumentError)
          end
        end
      end
    end

    describe "#[]" do
      context "when correct arguments" do
        context "when has defined handler" do
          it "returns handler" do
            subject.handle(exception, with: handler)

            expect(subject[exception]).to eq handler
          end
        end

        context "when has no defined handler" do
          it "returns default handler" do
            expect(subject[exception]).to eq default_handler
          end
        end
      end

      context "when wrong arguments" do
        context "when `exception` is `nil` or not given" do
          it "raises an exception" do
            expect { subject[] }.to raise_error(ArgumentError)
          end
        end
      end
    end
  end
end
