class ConciergeMailer < ActionMailer::Base
  default from: "noreply@reservebar.com"

  def send_email(data)
    mail(
      to: 'nflanagan@reservebar.com, slesser@reservebar.com',
      subject: "Tiffany Email Submitted",
      body: data
    )
  end

end
