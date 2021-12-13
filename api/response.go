package api

import (
	"errors"
	"fmt"
)

type Response struct {
	Result    string `json:"result,omitempty"`
	ErrorCode string `json:"errorCode,omitempty"`
	ErrorMsg  string `json:"errorMsg,omitempty"`
}

func (b Response) Failed() bool {
	return b.Result == "fail"
}

func (b Response) Succeeded() bool {
	return b.Result == "success" && b.ErrorCode == "200"
}

func (b Response) Error() error {
	if b.Failed() {
		return errors.New(fmt.Sprintf("%s: %s", b.ErrorCode, b.ErrorMsg))
	}
	return nil
}

func (b Response) ResetIsSuccessful() bool {
	return b.Succeeded() && b.ErrorMsg == "GNL"
}
