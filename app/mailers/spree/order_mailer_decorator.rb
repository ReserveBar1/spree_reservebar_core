Spree::OrderMailer.class_eval do
  default :from => "ReserveBar Orders <no-reply@reservebar.com>"

  # sent to giftor
  def confirm_email(order, resend = false)
    @order = order
    subject = (resend ? "[#{t(:resend).upcase}] " : '')
    subject += "#{t('order_mailer.confirm_email.subject')}"
    mail(:to => order.email, :reply_to => "support@reservebar.com", :bcc => Spree::Config[:mail_bcc], :subject => subject)
  end

  def cancel_email(order, resend = false)
    @order = order
    subject = (resend ? "[#{t(:resend).upcase}] " : '')
    subject += "#{t('order_mailer.cancel_email.subject')}"
    mail(:to => order.email, :reply_to => "order@reservebar.com", :bcc => Spree::Config[:mail_bcc], :subject => subject)
  end

  def cancel_email_retailer(order, resend = false)
    @order = order
    subject = (resend ? "[#{t(:resend).upcase}] " : '')
    subject += "#{t('order_mailer.cancel_email.subject')}"
    mail(:to => order.retailer.email, :reply_to => "orders@reservebar.com", :bcc => Spree::Config[:mail_bcc], :subject => subject)
  end

  def giftor_shipped_email(order, resend=false)
    @order = order
    subject = (resend ? "[#{t(:resend).upcase}] " : "")
    subject += "#{t('order_mailer.giftor_shipped_email.subject')}"
    mail(:to => order.email, :reply_to => "support@reservebar.com", :bcc => Spree::Config[:mail_bcc], :subject => subject)
  end

  def giftor_delivered_email(order, resend=false)
    @order = order
    subject = (resend ? "[#{t(:resend).upcase}] " : "")
    subject += "#{t('order_mailer.giftor_delivered_email.subject')}"
    mail(:to => order.email, :reply_to => "support@reservebar.com", :bcc => Spree::Config[:mail_bcc], :subject => subject)
  end

  # sent to giftee
  def giftee_notify_email(order, resend=false)
    unless order.gift.email.blank?
      @order = order
      subject = (resend ? "[#{t(:resend).upcase}] " : "")
      subject += "#{t('order_mailer.giftee_notify_email.subject')}"
      mail(:to => order.gift.email, :reply_to => "support@reservebar.com", :bcc => Spree::Config[:mail_bcc], :subject => subject)
    end
  end

  def giftee_shipped_email(order, resend=false)
    unless order.gift.email.blank?
      @order = order
      subject = (resend ? "[#{t(:resend).upcase}] " : "")
      subject += "#{t('order_mailer.giftee_shipped_email.subject')}"
      mail(:to => order.gift.email, :reply_to => "support@reservebar.com", :bcc => Spree::Config[:mail_bcc], :subject => subject)
    end
  end

  # sent to retailer
  def retailer_submitted_email(order, resend=false)
    @order = order
    subject = (resend ? "[#{t(:resend).upcase}] " : "")
    subject += "#{t('order_mailer.retailer_submitted_email.subject')}"
    mail(:to => order.retailer.email, :reply_to => "orders@reservebar.com", :bcc => Spree::Config[:mail_bcc], :subject => subject)
  end

  # removed from retailer
  def retailer_removed_email(order, retailer, resend=false)
    @order = order
    @old_retailer = retailer
    subject = (resend ? "[#{t(:resend).upcase}] " : "")
    subject += "#{t('order_mailer.retailer_removed_email.subject')}"
    mail(:to => @old_retailer.email, :reply_to => "orders@reservebar.com", :bcc => Spree::Config[:mail_bcc], :subject => subject)
  end

  # send email to reservebar.com that retailer has accepted an order
  def accepted_notification(order, resend = false)
    @order = order
    @retailer = @order.retailer
    subject = (resend ? "[#{t(:resend).upcase}] " : "")
    subject += "#{t('order_mailer.accepted_notification.subject')} ##{order.number}"
    mail(:to => Spree::Config[:mail_notification_to], :subject => subject)
  end

  # send email to reservebar.com with all orders that have not been accepted yet
  def not_accepted_notification(hours = 6, resend = false)
    @hours = hours
    @orders = Spree::Order.not_accepted_hours(hours).order("spree_orders.updated_at desc")
    subject = (resend ? "[#{t(:resend).upcase}] " : "")
    subject += "Orders that have not been accepted more than #{hours} hours"
    mail(:to => Spree::Config[:mail_notification_to], :subject => subject)
  end

  # Regular status email to management - indicates if any orders are not progressing as needed
  def regular_reminder_email(resend = false)
    @retailers = Spree::Retailer.active
    subject = (resend ? "[#{t(:resend).upcase}] " : "")
    subject += "#{t('order_mailer.regular_reminder_email.subject')}"
    mail(:to => Spree::Config[:mail_notification_to], :reply_to => "orders@reservebar.com", :subject => subject)
  end

  # Send email to Neil/Janet if a payment capture fails for some reason
  def capture_payment_error_notification(order, error)
    @order = order
    @error = error
    subject = "Payment Capture Failed - #{order.number}"
    mail(:to => "nflanagan@reservebar.com, jgroves@reservebar.com", :subject => subject)
  end

  # Send email to Neil/Janet if there is no payment on an order
  def no_payment_error_notification(order)
    @order = order
    subject = "No Payment for #{order.number}"
    mail(:to => "nflanagan@reservebar.com, jgroves@reservebar.com", :subject => subject, body: 'Retailer tried to accept, but no payment was found.')
  end

end
