
def get_app(app)
  app == "phpIPAM" ? IpamApp.new : ForemanApp.new 
end
