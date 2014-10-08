ActiveAdmin.register User do

  
  # See permitted parameters documentation:
  # https://github.com/gregbell/active_admin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params(
    :email,
    :encrypted_password,
    :reset_password_token,
    :reset_password_sent_at,
    :remember_created_at,
    :sign_in_count,
    :current_sign_in_at,
    :last_sign_in_at,
    :current_sign_in_ip,
    :last_sign_in_ip,
    :created_at,
    :updated_at,
    :confirmation_token,
    :confirmed_at,
    :confirmation_sent_at,
    :unconfirmed_email,
    :first_name,
    :last_name,
    :provider,
    :uid,
    :name,
    :timezone,
    :gender,
    :facebook_image,
    :username,
    :premium,
    :upgrade_date,
    :stripe_cus_id,
    :phone_number,
    :organization_id,
    :admin
  )
  #
  # or
  #
  # permit_params do
  #  permitted = [:permitted, :attributes]
  #  permitted << :other if resource.something?
  #  permitted
  # end

  ActiveAdmin.register User do
    show do |user|
      attributes_table do
        row :first_name
        row :last_name
        row :organization do
          link_to user.organization.name, admin_organization_path(user.organization) if user.organization
        end
        row :username
        row :email
        row :phone_number
        row :volunteer_hours_earned
        row :volunteer_hours_used
        row :hours_left_to_use
        row :bids_made do
          user.bids.map do |bid|
            link_to("#{bid.winning ? 'Won' : 'Lost'}: #{bid.reward.title} (#{bid.hours} #{'hours'.pluralize(bid.hours)})", admin_bid_path(bid))
          end.join(", ").html_safe
        end
        row :premium
        row :upgrade_date
        row :admin
        row :sign_in_count
        row :current_sign_in_at
        row :last_sign_in_at
        row :current_sign_in_ip
        row :last_sign_in_ip
        row :confirmation_token
        row :confirmed_at
        row :confirmation_sent_at
        row :unconfirmed_email
        row :provider
        row :uid
        row :name
        row :timezone
        row :gender
        row :facebook_image
        row :stripe_cus_id
        row :encrypted_password
        row :reset_password_token
        row :reset_password_sent_at
        row :remember_created_at
        row :created_at
        row :updated_at
      end
      active_admin_comments
    end
  end
end
