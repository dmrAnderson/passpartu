RSpec.describe Passpartu do
  it 'has a version number' do
    expect(described_class::VERSION).not_to be nil
  end

  context 'default policy' do
    it "set default policy file to './config/passpartu.yml'" do
      expect(described_class.config.policy_file).to eq './config/passpartu.yml'
    end

    context 'set default policy to match policy_file rules' do
      it 'for admin' do
        policy = described_class.config.policy
        expect(policy.dig('admin', 'orders', 'create')).to be_truthy
        expect(policy.dig('admin', 'orders', 'edit')).to be_truthy
        expect(policy.dig('admin', 'orders', 'delete')).to be_truthy

        expect(policy.dig('admin', 'products', 'create')).to be_falsey
        expect(policy.dig('admin', 'products', 'edit')).to be_truthy
        expect(policy.dig('admin', 'products', 'delete')).to be_truthy
      end

      it 'for manager' do
        policy = described_class.config.policy
        expect(policy.dig('manager', 'orders', 'create')).to be_truthy
        expect(policy.dig('manager', 'orders', 'edit')).to be_truthy
        expect(policy.dig('manager', 'orders', 'delete')).to be_falsey

        expect(policy.dig('manager', 'products', 'create')).to be_truthy
        expect(policy.dig('manager', 'products', 'edit')).to be_truthy
        expect(policy.dig('manager', 'products', 'delete')).to be_falsey
      end
    end
  end

  context 'custom policy' do
    it "set custom policy file to './config/passpartu_custom.yml'" do
      described_class.configure do |config|
        config.policy_file = './config/passpartu_custom.yml'
      end
      expect(described_class.config.policy_file).to eq './config/passpartu_custom.yml'
    end

    context 'set default policy to match policy_file rules' do
      it 'for admin' do
        policy = described_class.config.policy
        expect(policy.dig('admin', 'orders', 'create')).to be_falsey
        expect(policy.dig('admin', 'orders', 'edit')).to be_falsey
        expect(policy.dig('admin', 'orders', 'delete')).to be_falsey

        expect(policy.dig('admin', 'products', 'create')).to be_truthy
        expect(policy.dig('admin', 'products', 'edit')).to be_truthy
        expect(policy.dig('admin', 'products', 'delete')).to be_truthy
      end

      it 'for manager' do
        policy = described_class.config.policy
        expect(policy.dig('manager', 'orders', 'create')).to be_truthy
        expect(policy.dig('manager', 'orders', 'edit')).to be_truthy
        expect(policy.dig('manager', 'orders', 'delete')).to be_falsey

        expect(policy.dig('manager', 'products', 'create')).to be_truthy
        expect(policy.dig('manager', 'products', 'edit')).to be_truthy
        expect(policy.dig('manager', 'products', 'delete')).to be_falsey
      end
    end
  end

  context 'when custom policy file not found' do
    it 'raises PolicyYmlNotFoundError' do
      expect { described_class.configure { |config| config.policy_file = './not_config/not_policy.yml' } }.to raise_error(described_class::PolicyYmlNotFoundError)
    end
  end

  context 'set check_waterfall' do
    context 'to be true' do
      before { described_class.config.raise_policy_missed_error = true }

      it 'set raise_policy_missed_error to false' do
        expect(described_class.config.raise_policy_missed_error).to be_truthy

        described_class.configure { |config| config.check_waterfall = true }

        expect(described_class.config.raise_policy_missed_error).to be_falsey
      end
    end

    context 'to be false' do
      context 'raise_policy_missed_error: true' do
        before { described_class.config.raise_policy_missed_error = true }

        it 'does not change raise policy missed error' do
          expect(described_class.config.raise_policy_missed_error).to be_truthy

          described_class.configure { |config| config.check_waterfall = true }

          expect(described_class.config.raise_policy_missed_error).to be_falsey
        end
      end

      context 'raise_policy_missed_error: false' do
        before { described_class.config.raise_policy_missed_error = false }

        it 'does not change raise policy missed error' do
          expect(described_class.config.raise_policy_missed_error).to be_falsey

          described_class.configure { |config| config.check_waterfall = false }

          expect(described_class.config.raise_policy_missed_error).to be_falsey
        end
      end
    end
  end
end
