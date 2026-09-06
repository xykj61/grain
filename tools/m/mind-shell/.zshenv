# The MIND jail gives every child shell the same repository-local Git doorway.
if [[ -n "${GRAIN_MIND_ROOT:-}" ]]; then
  export PATH="${GRAIN_MIND_ROOT}/tools/m/mind-bin:${PATH}"
fi
