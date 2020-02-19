#!/usr/bin/env bashio

DB_PATH=$(bashio::config 'db_path')
SUPER_USER=$(bashio::config 'super_user')
SUPER_PASS=$(bashio::config 'super_pass')
SUPER_EMAIL=$(bashio::config 'super_email')
# shellcheck disable=SC2198
#if [ -n "$@" ]; then
#  exec "$@"
#fi

bashio::log.info "Setting up etesync"

if ! bashio::fs.file_exists "${DB_PATH}}"; then
  bashio::log.info "First Run, Setting up DB"
  "$BASE_DIR"/manage.py migrate

  bashio::log.info "Creating Super User"
  echo "from django.contrib.auth.models import User; User.objects.create_superuser('$SUPER_USER' , '$SUPER_EMAIL', '$SUPER_PASS')" | python manage.py shell
fi