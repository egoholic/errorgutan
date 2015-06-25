RSpec.describe Errorgutan::Aliases do
  let(:exception_class) { FakeException }
  let(:aliased_exception_class) { AliasedException }

  describe "instance" do
    describe "#bind" do
      context "when correct arguments" do
        it "creates an alias" do
          expect { subject.bind(exception_class, with: aliased_exception_class) }
            .to change { subject[exception_class] }
              .from(nil)
              .to(aliased_exception_class)
        end
      end

      context "when wrong arguments" do
        context "when `exception` and alias `with:` are `nil` or not provided" do
          it "raises an exception" do
            expect { subject.bind(nil, with: nil) }.to raise_error(ArgumentError)
            expect { subject.bind }.to raise_error(ArgumentError)
          end
        end

        context "when `exception` is `nil` or not provided" do
          it "raises an exception" do
            expect { subject.bind(nil, with: aliased_exception_class) }.to raise_error(ArgumentError)
            expect { subject.bind(with: aliased_exception_class) }.to raise_error(ArgumentError)
          end
        end

        context "when alias `with:` is `nil` or not provided" do
          it "raises an exception" do
            expect { subject.bind(exception_class, with: nil) }.to raise_error(ArgumentError)
            expect { subject.bind(exception_class) }.to raise_error(ArgumentError)
          end
        end
      end
    end

    describe "#[]" do
      context "when correct arguments" do
        context "when has alias" do
          it "returns an alias" do
            subject.bind exception_class, with: aliased_exception_class

            expect(subject[exception_class]).to be aliased_exception_class
          end
        end

        context "when has no alias" do
          it "returns `nil`" do
            expect(subject[exception_class]).to be_nil
          end
        end
      end

      context "when wrong arguments" do
        context "when `exception` is `nil` or not provided" do
          it "raises an exception" do
            expect { subject[nil] }.to raise_error(ArgumentError)
            expect { subject[] }.to raise_error(ArgumentError)
          end
        end
      end
    end
  end
end
