# Тестовое задание

Я пытался сделать тестовое задание и параллельно изучал tarantool и lua. По этому я не использовал встроенные возможности по развертыванию http api на основе конфигурации yaml. Сделал все в коде на lua. Сделал я упрощенное api для todo листов. Пока без пользователей аутентификации и тд.

Я вынес всю логику в папку app/core. Там есть подпапки api и storage, внутри этих папок есть файлы list-controller и task-controller, а также list-storage и task-storage. Для api я сделал базовый класс BaseController, который реализует CRUD операции на основе параметров конструктора. TaskController и ListController наследуются от него.

Я сделал так что bucket_id генерируется по list_id. То есть каждый список в отдельном сегменте
```
list: {
  title: string,
  text: string
}
```
```
task: {
  list_id: UUID,
  title: string,
  text: string,
  completed: boolean
}
```
### Маршруты
#### Tasks
GET http://mkyzyma.ru:8081/tasks[?list_id={list_id}]

GET http://mkyzyma.ru:8081/tasks/:id

POST http://mkyzyma.ru:8081/tasks

PUT http://mkyzyma.ru:8081/tasks/:id

DELETE http://mkyzyma.ru:8081/tasks/:id

#### Lists

GET http://mkyzyma.ru:8081/lists

GET http://mkyzyma.ru:8081/lists/:id

POST http://mkyzyma.ru:8081/lists

PUT http://mkyzyma.ru:8081/lists/:id

DELETE http://mkyzyma.ru:8081/lists/:id

### Примеры
##### Добавить список:
```
curl -X POST -v -H "Content-Type: application/json" -d '{
"title": "qwerty", "text": "asdf"}' http://mkyzyma.ru:8081/lists
```
##### Добавить задачу:
```
curl -X POST -v -H "Content-Type: application/json" -d '{
"title": "qwerty", "text": "asdf", "completed": true, "list_id": "73f73760-e7a5-4666-910f-733c3b89583c"
}' http://mkyzyma.ru:8081/tasks
```
##### Получить все задачи:
```
curl -X GET -v -H "Content-Type: application/json"  http://localhost:8081/tasks
```
##### Получить все задачи списка:
```
curl -X GET -v -H "Content-Type: application/json"  http://localhost:8081/tasks\?list_id\=842b7611-e863-4356-b96d-882415d0f08c
```
