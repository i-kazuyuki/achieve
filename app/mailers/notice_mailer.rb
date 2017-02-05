class NoticeMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notice_mailer.sendmail_blog.subject
  #

  # blogの情報を引数として渡すので、仮引数(blog)を追加。
  def sendmail_blog(blog)
    @blog = blog

    mail to: "k.ishijima18@gmail.com",
      subject: '【Achieve】ブログが投稿されました'
  end

  def sendmail_contact(contact)
    @contact = contact

    mail to: @contact.email,
        subject: '[Achieve]お問い合わせが完了しました'
  end
end
