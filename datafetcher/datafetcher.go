package main

import (
    "fmt"
    "net/http"
    "os"
    "github.com/parnurzeal/gorequest"
)

type Match struct {
    Id string
    ApiKey string
    DataDirectory string
}

func (match *Match) Url() (string) {
    return fmt.Sprintf("https://na.api.pvp.net/api/lol/na/v2.2/match/%s?includeTimeline=true&api_key=%s", match.Id, match.ApiKey)
}

func (match *Match) DataFilePath() (string) {
    return fmt.Sprintf("%s/%s.json", match.DataDirectory, match.Id)
}

func (match *Match) Fetch() (string, error) {
    resp, body, errs := gorequest.New().Get(match.Url()).End()
    if errs != nil || resp.StatusCode != http.StatusOK {
        return "", fmt.Errorf("Error fetching data for: %q. Response: %q", match.Url(), body)
    }
    return body, nil
}

func (match *Match) FetchAndSave() (error) {
    data, err := match.Fetch()
    if err == nil {
        dataFile, _ := os.Create(match.DataFilePath())
        dataFile.WriteString(data)
    }
    return err
}

func main() {
    match := Match{Id: "1778704162", ApiKey: os.Getenv("RIOT_API_KEY"), DataDirectory: "../data"}
    err := match.FetchAndSave()
    if err != nil {
        fmt.Println(err)
    }
}
