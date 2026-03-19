package main

import (
	"syscall/js"

	"github.com/skip2/go-qrcode"
)

func generateQR(this js.Value, args []js.Value) interface{} {
	if len(args) < 1 {
		return nil
	}

	url := args[0].String()

	png, err := qrcode.Encode(url, qrcode.Medium, 256)
	if err != nil {
		return nil
	}

	uint8Array := js.Global().Get("Uint8Array").New(len(png))
	js.CopyBytesToJS(uint8Array, png)

	return uint8Array
}

func main() {
	js.Global().Set("generateQR", js.FuncOf(generateQR))
	select {}
}
