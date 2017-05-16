require 'rails_helper'

describe Contact do
  let(:contact){ Contact.new }
  let(:contacts){ Contact.new(name: '石島', email: 'foo@example.com', content: '内容') }
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

feature "contact" do
  background do
    Contact.new(name: '石島', email: 'foo@example.com', content: 'hogehoge')
  end
  scenario "問い合わせ送信" do
    visit '/contacts/new'
    # save_and_open_page
    fill_in 'contact_name', with: '石島'
    fill_in 'contact_email', with: 'foo@example.com'
    fill_in 'contact_content', with: 'hogehoge'
    click_button '確認する'
    expect(page).to have_content '以下の内容で、送信する。'
    click_button '送信する'
    expect(page).to have_content 'お問い合わせありがとうございました！'
  end
end
