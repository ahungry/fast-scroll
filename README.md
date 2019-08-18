# fast-scroll

Ever run into scrolling issues that drive you crazy? (pauses and lag
when trying to run through the buffer)

If you have a fair amount of packages and customizations (particularly
if they are mode-line / font-lock heavy) then this is the package to
help alleviate that a bit for you.

It works by temporarily disabling font-lock and switching to a
barebones mode-line, until you stop scrolling (at which point it re-enables).

# Usage

In your init file add something such as:

```elisp
(add-to-list 'load-path "~/src/elisp/fast-scroll") ; Or wherever you cloned it
(require 'fast-scroll)
;; If you would like to turn on/off other modes, like flycheck, add
;; your own hooks.
(add-hook 'fast-scroll-start-hook (lambda () (flycheck-mode -1)))
(add-hook 'fast-scroll-end-hook (lambda () (flycheck-mode 1)))
(fast-scroll-config)
(fast-scroll-minor-mode 1)
```

it will wrap some common scroll commands.

This works really well when you turn up repeat rate in Xorg as well:

```
xset r rate 250 60
```

# Customization

You can adjust the 'throttle' rate (how fast subsequent scroll
commands must come in bound) as such:

```elisp
(setq fast-scroll-throttle 0.5)
```

# Copyright

Matthew Carter <m@ahungry.com>

# License

AGPLv3 or later
