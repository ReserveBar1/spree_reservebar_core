class ConciergeMailer < ActionMailer::Base
  default from: "noreply@reservebar.com"

  def send_email(data, brand_name)
    if brand_name.downcase == 'tiffany'
      mail(
        to: 'danf@reservebar.com',
        cc: 'nflanagan@reservebar.com',
        subject: "#{brand_name} Email Submitted",
        body: data
      )
    else
      mail(
        to: 'nflanagan@reservebar.com, slesser@reservebar.com',
        subject: "#{brand_name} Email Submitted",
        body: data
      )
    end
  end

end
