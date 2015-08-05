class TiffanyMailer < ActionMailer::Base
  default from: "noreply@reservebar.com"

  def send_email(data)
    mail(
      to: 'jknebel@reservebar.com, lpereira@reservebar.com',
      subject: "Tiffany Email Submitted",
      body: data
    )
  end

end
