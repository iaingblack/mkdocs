# Windows Tips

## Dockerfiles

### Escape Character - [Link](https://docs.docker.com/engine/reference/builder/#escape)
It is useful to add this to your docker file;

```
# escape=`
```

This changes the escape character to be a ` and not \
This means windows filepaths do not have to be double escaped (c:\windows now, yah!) and also that it functions like powershell for things that have a $. For example;

```
start-service MSSQL`$SERVER
```
