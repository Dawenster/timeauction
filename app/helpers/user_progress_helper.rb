module UserProgressHelper
  def fetch_progress_steps(user)
    steps = [
      {
        :title => "Connect your Facebook",
        :done => !user.uid.nil?,
        :action => Rails.application.routes.url_helpers.user_omniauth_authorize_path(:facebook),
        :action_type => "link"
      },
      {
        :title => "Add a description of yourself",
        :done => !user.about.blank?,
        :action => "toggleAboutInput()",
        :action_type => "angular"
      },
      {
        :title => "Log volunteer hours",
        :done => user.hours_entries.logged.any?,
        :action => Rails.application.routes.url_helpers.add_karma_path,
        :action_type => "link"
      },
      {
        :title => "Donate to a charity",
        :done => user.donations.given.any?,
        :action => Rails.application.routes.url_helpers.add_karma_path,
        :action_type => "link"
      },
      {
        :title => "Bid on an auction",
        :done => user.bids.any?,
        :action => Rails.application.routes.url_helpers.auctions_path,
        :action_type => "link"
      }
      # {
      #   :title => "Share on Facebook",
      #   :done => false,
      #   :action => "#"
      # }
    ]#.sort_by{|step| step[:done] ? 0 : 1}
    steps.delete_at(3) if $hk
    return steps
  end
end