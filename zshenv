function exists() {
  # `command -v` is similar to `which`
  # `$1` first argument of the function
  # `>/dev/null` redirects the successfull output to /dev/null (a black hole)
  # `2>&1` redirects the error output to the same output as the standard input (/dev/null)
  command -v $1 >/dev/null 2>&1
  # If the function succeeds the exit code is `0` (and CAN be chained with `&&`)
  # Otherwise the function fails with a non-zero exit code (thus, it CANNOT be chained with `&&`)
}
