RSpec.describe Errorgutan::Manager do
  let(:exception) { FakeException.new("fake exception") }
  let(:aliases) { Errorgutan::Aliases.new }
  let(:default_handler) { Errorgutan::Handler.new { |e| {handled: true} } }
  let(:handler) { Errorgutan::Handler.new { |e| {exception_class: e.class} } }
  let(:exceptions_handlers) { Errorgutan::ExceptionsHandlers.new default: default_handler }

  describe "class" do
    subject { described_class }

    describe ".new" do
      context "when correct arguments" do
        it "returns it's own instance" do
          expect(subject.new(aliases, exceptions_handlers)).to be_a(described_class)
        end
      end

      context "when wrong arguments" do
        context "when `aliases` and `exceptions_handlers` are nil or not given" do
          it "raises an exception" do
            expect { subject.new nil, nil }.to raise_error(ArgumentError)
            expect { subject.new }.to raise_error(ArgumentError)
          end
        end

        context "when `aliases` is not an instance of `Errorgutan::Aliases`" do
          it "raises an exception" do
            expect { subject.new true, exceptions_handlers }.to raise_error(ArgumentError)
          end
        end

        context "when `exceptions_handlers` is not an instance of `Errorgutan::ExceptionsHandlers` or not given" do
          it "raises an exception" do
            expect { subject.new aliases, true }.to raise_error(ArgumentError)
            expect { subject.new aliases }.to raise_error(ArgumentError)
          end
        end
      end
    end
  end

  describe "instance" do
    subject { described_class.new aliases, exceptions_handlers }

    describe "#manage" do
      shared_examples "a correct exception manager" do
        context "when exception has defined handler" do
          it "uses handler to handle an exception" do
            exceptions_handlers.bind FakeException, to: handler

            expect(subject.manage { raise exception }).to eq({exception_class: exception_class})
          end
        end

        context "when exception has no defined handler" do
          it "uses default handler to handle an exception" do
            expect { subject.manage { raise exception } }
              .to raise_error(FakeException)
                .with_message("from default handler")
          end
        end
      end

      context "when exception raised" do
        context "when exception has alias" do
          before { aliases.bind FakeException, with: AliasedException }

          context "when exception has defined handler" do
            it "uses handler to handle an exception" do
              exceptions_handlers.bind AliasedException, to: handler

              expect(subject.manage { raise exception }).to eq({exception_class: AliasedException})
            end
          end

          context "when exception has no defined handler" do
            it "uses default handler to handle an exception" do
              expect(subject.manage { raise exception }).to eq({handled: true})
            end
          end
        end

        context "when exception has no alias" do
          context "when exception has defined handler" do
            it "uses handler to handle an exception" do
              exceptions_handlers.bind FakeException, to: handler

              expect(subject.manage { raise exception }).to eq({exception_class: FakeException})
            end
          end

          context "when exception has no defined handler" do
            it "uses default handler to handle an exception" do
              expect(subject.manage { raise exception }).to eq({handled: true})
            end
          end
        end
      end

      context "when exception isn't raised" do
        it "normally executes block of code" do
          expect(subject.manage { "success" }).to eq "success"
        end
      end
    end
  end
end
