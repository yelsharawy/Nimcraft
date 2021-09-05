when defined release:
    switch("out","out/release/nimcraft")
    switch("opt","speed")
else:
    switch("out","out/debug/nimcraft")
    when defined debug:
        --debugger:native