require 'rails_helper'

describe Contact do
  let(:contact){ Contact.new }
  let(:contacts){ Contact.new(name: '石島', email: 'hoge@gamil.com', content: '内容') }
  # contactがname,email,contentがあれば有効
  it { expect(contacts).to be_valid }
  # contactがname,email,contentがなければ無効
  it { expect(contact).not_to be_valid }
  # nameなしではエラーが発生する
  it "is error without name" do
    contact.valid?
    expect(contact.errors[:name]).to include("を入力してください")
  end
  # emailなしではエラーが発生する
  it "is error without email" do
    contact.valid?
    expect(contact.errors[:email]).to include("を入力してください")
  end
  # contentなしではエラーが発生する
  it "is error without content" do
    contact.valid?
    expect(contact.errors[:content]).to include("を入力してください")
  end
end
