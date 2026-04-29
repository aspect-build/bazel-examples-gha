import type { LogMessage } from '../schema/logger_pb';

class ServerLogs {
  getServerLogs(): Promise<LogMessage[] | undefined> {
    return fetch('http://localhost:8081')
      .then((response) => this.checkStatus(response))
      .then((response) =>
        this.parseJSON(response)
          .then((response) => {
            return Promise.resolve(this.displayServerLogs(response));
          })
          .catch((error) => this.throwError(error))
      );
  }

  private checkStatus(response: Response): Promise<Response> {
    console.log('in check status');
    if (response.status >= 200 && response.status < 300) {
      return Promise.resolve(response);
    } else {
      const error = new Error(response.statusText);
      throw error;
    }
  }

  private parseJSON(response: Response): Promise<Response> {
    console.log('in parse json');
    return response.json();
  }

  private timestampToString(timestamp): string {
    // https://stackoverflow.com/questions/847185/convert-a-unix-timestamp-to-time-in-javascript
    const date = new Date(timestamp * 1000);
    const hours = date.getHours();
    const minutes = '0' + date.getMinutes();
    const seconds = '0' + date.getSeconds();
    const formattedTime =
      hours + ':' + minutes.substr(-2) + ':' + seconds.substr(-2);
    return formattedTime;
  }

  private displayServerLogs(data: Response) {
    console.log('in display');

    const el: HTMLElement = document.getElementById('log_results')!;
    el.innerHTML = '';

    const jsonData = JSON.parse(JSON.stringify(data));
    for (const entry of jsonData) {
      const logElement: HTMLDivElement = document.createElement('div');

      let entryHTML = '';
      entryHTML += "<b>message:</b> '" + entry.message;
      entryHTML +=
        "' received at <b>time:</b> " + this.timestampToString(entry.time);
      logElement.innerHTML = entryHTML;

      el.appendChild(logElement);
      console.log(entry);
    }

    document.body.appendChild(el);

    return undefined;
  }

  private throwError(error) {
    const el: HTMLElement = document.getElementById('log_results')!;
    el.innerHTML = 'No logs found, sorry. Try again once the server has logs?';
    console.log(error);
    return Promise.reject(error);
  }
}

const serverLogs = new ServerLogs();
const button = document.createElement('button');
button.textContent = 'Get Server Logs';
button.onclick = function () {
  serverLogs.getServerLogs();
};

const logResultsDiv = document.createElement('div');
logResultsDiv.setAttribute('id', 'log_results');

document.body.appendChild(button);
document.body.appendChild(logResultsDiv);
