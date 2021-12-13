package api

import (
	"encoding/json"
	"fmt"
	"net/http"
	"time"
)

const BaseURL = "https://developer.lge.com/secure"

type Client struct {
	client *http.Client
	token  string
}

func New(token string) *Client {
	return &Client{
		client: &http.Client{Timeout: time.Second * 10},
		token:  token,
	}
}

func (c *Client) call(method string, target interface{}) (err error) {
	req, err := http.NewRequest(http.MethodGet, fmt.Sprintf("%s/%s.dev?sessionToken=%s", BaseURL, method, c.token), nil)
	if err != nil {
		return err
	}

	res, err := c.client.Do(req)
	if err != nil {
		return err
	}

	defer res.Body.Close()

	err = json.NewDecoder(res.Body).Decode(target)
	return
}

func (c *Client) Query() (timeLeft string, err error) {
	var res Response
	if err = c.call("CheckDevModeSession", &res); err != nil {
		return
	}
	if res.Failed() {
		err = res.Error()
		return
	}
	return res.ErrorMsg, nil
}

func (c *Client) Extend() (err error) {
	var res Response
	if err = c.call("ResetDevModeSession", &res); err != nil {
		return
	}
	if res.Failed() || !res.ResetIsSuccessful() {
		err = res.Error()
		return
	}
	return
}
