yarn
NODE_ENV='production' npm run build
MIX_ENV=prod mix deps.get
MIX_ENV=prod mix deps.compile
MIX_ENV=prod mix compile
MIX_ENV=prod mix phoenix.digest
