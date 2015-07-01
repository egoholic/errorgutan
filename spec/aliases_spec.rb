RSpec.describe Errorgutan::Aliases do
  let(:exception_class) { FakeException }
  let(:aliased_exception_class) { AliasedException }

  describe "instance" do
    describe "#bind" do
      context "when correct arguments" do
        it "creates an alias" do
          expect { subject.bind([exception_class], with: aliased_exception_class) }
            .to change { subject[exception_class] }
              .from(nil)
              .to(aliased_exception_class)
        end
      end

      context "when wrong arguments" do
        it "raises ArgumentError" do
          expect { subject.bind(nil, with: nil) }.to raise_error(ArgumentError)
          expect { subject.bind }.to raise_error(ArgumentError)
          expect { subject.bind(Class.new, with: Class.new) }.to raise_error(ArgumentError)

          expect { subject.bind(nil, with: aliased_exception_class) }.to raise_error(ArgumentError)
          expect { subject.bind(with: aliased_exception_class) }.to raise_error(ArgumentError)
          expect { subject.bind(Class.new, with: aliased_exception_class) }.to raise_error(ArgumentError)

          expect { subject.bind([exception_class], with: nil) }.to raise_error(ArgumentError)
          expect { subject.bind([exception_class]) }.to raise_error(ArgumentError)
          expect { subject.bind([exception_class], with: Class.new) }.to raise_error(ArgumentError)

          expect { subject.bind [nil, exception_class], with: aliased_exception_class }.to raise_error(ArgumentError)
          expect { subject.bind [Class.new, exception_class], with: aliased_exception_class }.to raise_error(ArgumentError)
          expect { subject.bind [], with: aliased_exception_class }.to raise_error(ArgumentError)
        end
      end
    end

    describe "#[]" do
      context "when correct arguments" do
        context "when has alias" do
          it "returns an alias" do
            subject.bind [exception_class], with: aliased_exception_class

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
        context "when `exception` is `nil`, not provided or not an exception class" do
          it "raises ArgumentError" do
            expect { subject[nil] }.to raise_error(ArgumentError)
            expect { subject[] }.to raise_error(ArgumentError)
            expect { subject[Class.new] }.to raise_error(ArgumentError)
          end
        end
      end
    end
  end
end
