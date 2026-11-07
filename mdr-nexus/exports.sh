DB_PASSWORD_SOURCE="$(derive_entropy "${app_entropy_identifier}-db-password")"
MASTER_KEY_SOURCE="$(derive_entropy "${app_entropy_identifier}-master-key")"

# Both are passed through sha256 so they are exactly 64 hex characters: the form Nexus accepts for
# NEXUS_MASTER_KEY, and safe inside the database URL. They are derived from this Umbrel's seed, so they
# stay the same across restarts and updates. The master key encrypts the stored connector credentials:
# never change the label above.
export APP_MDR_NEXUS_DB_PASSWORD="$(printf '%s' "${DB_PASSWORD_SOURCE}" | sha256sum | cut -d ' ' -f1)"
export APP_MDR_NEXUS_MASTER_KEY="$(printf '%s' "${MASTER_KEY_SOURCE}" | sha256sum | cut -d ' ' -f1)"
