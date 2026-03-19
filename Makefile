ifeq ($(OS),Windows_NT)
    # Windows (Git Bash / MSYS)
    WASM_EXEC_GO := $(shell cygpath -u "$(shell go env GOROOT)/lib/wasm/wasm_exec.js")
    WASM_EXEC_TINYGO := $(shell cygpath -u "$(shell tinygo env TINYGOROOT)/targets/wasm_exec.js")
else
    # Linux / macOS
    WASM_EXEC_GO := $(shell go env GOROOT)/lib/wasm/wasm_exec.js
    WASM_EXEC_TINYGO := $(shell tinygo env TINYGOROOT)/targets/wasm_exec.js
endif

all: go tinygo

go: FORCE
	GOOS=js GOARCH=wasm go build -o go_01.wasm
	GOOS=js GOARCH=wasm go build -o go_02.wasm -ldflags="-s -w"
	cp go_02.wasm main.wasm
	cp "$(WASM_EXEC_GO)" .

tinygo: FORCE
	tinygo build -o tinygo_01.wasm -target wasm
	tinygo build -o tinygo_02.wasm -target wasm --no-debug
	tinygo build -o tinygo_03.wasm -target wasm --no-debug --panic=trap
	tinygo build -o tinygo_04.wasm -target wasm --no-debug --panic=trap --gc=leaking
	wasm-opt -Oz -o main.wasm tinygo_04.wasm
	cp "$(WASM_EXEC_TINYGO)" .

clean:
	rm *.wasm wasm_exec.js

FORCE:
