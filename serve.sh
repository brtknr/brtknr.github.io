# Kill existing instances of python to free the default SimpleHTTPServer port
killall python
# Run a SimpleHTTPServer on the default port to host MathJax.js
pushd ~/Sites/MathJax/; python -m SimpleHTTPServer & popd
# Then run the development Jekyll server
jekyll serve --config _config.yml,_config-dev.yml