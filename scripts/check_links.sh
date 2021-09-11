
curl --silent --location https://coder.com/docs/sitemap.xml | xmlstarlet select -N sitemap="http://www.sitemaps.org/schemas/sitemap/0.9" --template --value-of "/sitemap:urlset/sitemap:url/sitemap:loc" --nl -
