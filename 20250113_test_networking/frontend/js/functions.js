function post()
{
  fetch('http://127.0.0.1:2345', {
    method: 'POST',
    headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
    },
    body: JSON.stringify({ "id": 78912 })
})
   .then(response => response.json())
   .then(response => console.log(JSON.stringify(response)))
}

function get()
{
  fetch('http://127.0.0.1:2345', {
    method: 'GET',
    headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
    }
})
   .then(response => response.json())
   .then(response => console.log(JSON.stringify(response)))
}

function hello()
{
  fetch('http://127.0.0.1:2345/hello', {
    method: 'GET',
    headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
    }
})
   .then(response => response.json())
   .then(response => console.log(JSON.stringify(response)))
}