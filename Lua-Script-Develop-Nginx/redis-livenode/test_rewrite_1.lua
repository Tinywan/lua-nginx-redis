if ngx.req.get_uri_args()["jump"] == "1" then  
   return ngx.redirect("http://www.jd.com?jump=1", 302)
elseif   ngx.req.get_uri_args()["jump"] == "2" then 
    return 12
end
