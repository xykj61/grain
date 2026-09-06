# macOS path_helper runs before this file; restore the MIND Git doorway after it.
if [[ -n "${GRAIN_MIND_ROOT:-}" ]]; then
  export PATH="${GRAIN_MIND_ROOT}/tools/m/mind-bin:${PATH}"
fi
