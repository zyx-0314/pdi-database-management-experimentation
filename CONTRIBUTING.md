# Contributing to PDI Database Management Experimentation

Thank you for your interest in contributing! This guide will help you add new databases or management tools to the environment.

## Adding a New Database

To add a new database to the docker compose setup:

1. **Add the service to docker compose.yml**:
```yaml
  newdatabase:
    image: newdatabase:latest
    container_name: pdi-newdatabase
    environment:
      # Add necessary environment variables
      DB_USER: user
      DB_PASSWORD: password
    ports:
      - "PORT:INTERNAL_PORT"
    volumes:
      - newdatabase-data:/data/path
    networks:
      - db-network
    healthcheck:
      test: ["CMD", "health-check-command"]
      interval: 10s
      timeout: 5s
      retries: 5
```

2. **Add the volume declaration**:
```yaml
volumes:
  # ... existing volumes ...
  newdatabase-data:
```

3. **Update README.md**:
   - Add connection details
   - Add port information
   - Add usage examples

4. **Update .env.example** (if needed):
```env
NEWDB_USER=user
NEWDB_PASSWORD=password
```

5. **Create initialization script** (if applicable):
   - Add to `init-scripts/` directory
   - Name it appropriately (e.g., `newdb-init.sql`)

## Adding a New Management Tool

To add a new management tool:

1. **Add the service to docker compose.yml**:
```yaml
  newtool:
    image: newtool:latest
    container_name: pdi-newtool
    environment:
      # Configuration
    ports:
      - "WEB_PORT:INTERNAL_PORT"
    volumes:
      - newtool-data:/data
    networks:
      - db-network
    depends_on:
      - database1
      - database2
```

2. **Add volume declaration** (if needed)

3. **Update README.md**:
   - Add to management tools table
   - Add access URL and credentials

4. **Update start.sh**:
   - Add to the management tools section in `start_management()` function

## Best Practices

### Service Configuration
- Use descriptive container names with `pdi-` prefix
- Always include health checks when possible
- Use environment variables for configuration
- Map ports consistently (avoid conflicts)

### Volumes
- Always use named volumes for data persistence
- Never commit volume data to git
- Document what each volume contains

### Documentation
- Keep README.md up to date
- Add clear connection examples
- Document any special configuration requirements
- Include troubleshooting tips

### Security
- Use placeholder passwords in examples
- Add security warnings for production use
- Document how to change default credentials

## Testing Your Changes

Before submitting changes:

1. **Test the service starts**:
```bash
docker compose up -d your-service
docker compose ps your-service
```

2. **Test the connection**:
```bash
# Use appropriate client to test connection
```

3. **Check logs**:
```bash
docker compose logs your-service
```

4. **Test health check**:
```bash
docker inspect --format='{{.State.Health.Status}}' pdi-your-service
```

5. **Test cleanup**:
```bash
docker compose down
docker compose down -v
```

## Submitting Changes

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Update documentation
6. Submit a pull request

### Pull Request Checklist
- [ ] Service starts without errors
- [ ] Health check works (if applicable)
- [ ] Connection can be established
- [ ] README.md updated
- [ ] .env.example updated (if needed)
- [ ] No hardcoded secrets
- [ ] Volumes properly configured
- [ ] Port doesn't conflict with existing services

## Code Style

### docker compose.yml
- Use 2-space indentation
- Order services logically (by category)
- Include comments for complex configurations
- Keep environment variables alphabetically sorted

### Shell Scripts
- Follow existing style
- Add comments for complex logic
- Handle errors appropriately
- Test on both Linux and macOS (if possible)

## Questions?

Feel free to open an issue for:
- Questions about the setup
- Feature requests
- Bug reports
- Documentation improvements

## Resources

- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Docker Hub](https://hub.docker.com/) - Find database images
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)

Thank you for contributing! 🎉
