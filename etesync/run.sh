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

if ! bashio::fs.file_exists "${DB_PATH}"; then
  bashio::log.info "First Run, Setting up DB"
  "$BASE_DIR"/manage.py migrate

  bashio::log.info "Creating Super User"
  echo "from django.contrib.auth.models import User; User.objects.create_superuser('$SUPER_USER' , '$SUPER_EMAIL', '$SUPER_PASS')" | python manage.py shell
fi

if [ ! -e "/etesync/static/admin" ] || [ ! -e "/etesync/static/rest_framework" ]; then
  bashio::log.info "Static files are missing, lets do something about that...."
  mkdir -p "/etesync/static"
  "$BASE_DIR"/manage.py collectstatic
fi

uWSGI='/usr/local/bin/uwsgi --ini etesync.ini'

bashio::log.info "Starting Etesync"

"$BASE_DIR/manage.py" runserver 0.0.0.0:8564