# FNT scheduler - Doing actions on proper time
The project runs every minute, reads the time and day from [actions.csv](src/main/resources/actions.csv) and prints log if the runtime has matched with defined in the file.

## Development
[SchedulerService](src/main/java/com/fnt/scheduler/service/SchedulerService.java) class runs target [business logic](java_task_1_1.txt).

## Testing
[SchedulerServiceTest](src/test/java/com/fnt/scheduler/service/SchedulerServiceTest.java) tests SchedulerService.

## Running
Local run: `mvn spring-boot:run`

## Building
`mvn clean package`