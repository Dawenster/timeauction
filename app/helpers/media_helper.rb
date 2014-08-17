module MediaHelper
  def logos
    return {
      "cbc" => "https://s3-us-west-2.amazonaws.com/timeauction/media/news_logos/cbc_logo.png",
      "ctv" => "https://s3-us-west-2.amazonaws.com/timeauction/media/news_logos/ctv_logo.png",
      "metro" => "https://s3-us-west-2.amazonaws.com/timeauction/media/news_logos/metro_logo.png",
      "yahoo" => "https://s3-us-west-2.amazonaws.com/timeauction/media/news_logos/yahoo_logo.png",
      "msn" => "https://s3-us-west-2.amazonaws.com/timeauction/media/news_logos/msn_logo.png",
      "province" => "https://s3-us-west-2.amazonaws.com/timeauction/media/news_logos/province_logo.png",
      "chronicle_herald" => "https://s3-us-west-2.amazonaws.com/timeauction/media/news_logos/chronicle_logo.png",
      "city" => "https://s3-us-west-2.amazonaws.com/timeauction/media/news_logos/city_logo.png",
      "vancouver_sun" => "https://s3-us-west-2.amazonaws.com/timeauction/media/news_logos/vancouver_sun_logo.png",
      "680" => "https://s3-us-west-2.amazonaws.com/timeauction/media/news_logos/680_logo.png",
      "calgary_herald" => "https://s3-us-west-2.amazonaws.com/timeauction/media/news_logos/calgary_herald_logo.png",
      "winnipeg_free_press" => "https://s3-us-west-2.amazonaws.com/timeauction/media/news_logos/winnipeg_logo.png",
      "getinvolved" => "https://s3-us-west-2.amazonaws.com/timeauction/media/news_logos/getinvolved.png",
      "goodnet" => "https://s3-us-west-2.amazonaws.com/timeauction/media/news_logos/goodnet.png",
      "liverightnow" => "https://s3-us-west-2.amazonaws.com/timeauction/media/news_logos/liverightnow.png",
      "qsb" => "https://s3-us-west-2.amazonaws.com/timeauction/media/news_logos/qsb.png"
    }
  end

  def popular_logos
    return [
      logos["cbc"],
      logos["ctv"],
      logos["metro"],
      logos["yahoo"]
    ]
  end

  def links
    return {
      "cbc" => "http://www.cbc.ca/news/canada/hamilton/news/why-tim-hortons-co-founder-ron-joyce-is-ready-to-meet-with-you-1.2583951",
      "ctv" => "http://www.ctvnews.ca/sci-tech/want-to-meet-the-co-founder-of-tim-hortons-try-volunteering-1.1742124",
      "msn" => "http://tech.ca.msn.com/volunteering-website-trades-hours-for-prizes-1",
      "metro" => "http://metronews.ca/news/canada/980426/volunteering-website-trades-hours-for-prizes",
      "province" => "http://www.theprovince.com/technology/Want+meet+Hortons+cofounder+Volunteer+website+trades+hours+meetings/9651404/story.html",
      "chronicle_herald" => "http://thechronicleherald.ca/artslife/1195357-website-lets-you-pay-with-volunteer-hours-to-meet-someone-cool",
      "yahoo" => "http://ca.news.yahoo.com/want-meet-tim-hortons-co-founder-volunteer-website-140012221.html",
      "city" => "http://www.citynews.ca/2014/03/23/want-to-meet-tim-hortons-co-founder-volunteer-website-trades-hours-for-meetings/",
      "vancouver_sun" => "http://www.vancouversun.com/technology/Want+meet+Hortons+cofounder+Volunteer+website+trades+hours+meetings/9651404/story.html#757Live",
      "680" => "http://www.680news.com/2014/03/23/want-to-meet-tim-hortons-co-founder-volunteer-website-trades-hours-for-meetings/",
      "calgary_herald" => "http://www.calgaryherald.com/technology/Want+meet+Hortons+cofounder+Volunteer+website+trades+hours/9651404/story.html",
      "winnipeg_free_press" => "http://www.winnipegfreepress.com/canada/want-to-meet-tim-hortons-co-founder-volunteer-website-trades-hours-for-meetings-251777231.html",
      "getinvolved" => "https://www.getinvolved.ca/2014/06/convert-volunteer-hours-jumpstart-career-rev-rev/",
      "goodnet" => "http://www.goodnet.org/articles/time-more-valuable-than-money-at-this-good-doing-auction-site",
      "liverightnow" => "http://www.cbc.ca/liverightnow/tips-and-articles/getting-started/new-benefit-of-volunteering.html",
      "qsb" => "http://qsb.ca/magazine/summer-2014/features/start-ups-snapshot"
    }
  end

  def news
    return [
      "cbc",
      "ctv",
      "msn",
      "metro",
      "qsb",
      "province",
      "chronicle_herald",
      "yahoo",
      "city",
      "vancouver_sun",
      "680",
      "calgary_herald",
      "liverightnow",
      "goodnet",
      "getinvolved",
      "winnipeg_free_press"
    ]
  end
end