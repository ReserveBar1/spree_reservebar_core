class ConciergeMailer < ActionMailer::Base
  default from: "noreply@reservebar.com"

  def send_email(data, brand_name)
    mail(
      to: 'nflanagan@reservebar.com, slesser@reservebar.com',
      subject: "#{brand_name} Email Submitted",
      body: data
    )
  end

end
