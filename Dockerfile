# Multi-stage build for Rails application
FROM ruby:3.4.5-alpine AS base

# Install system dependencies
RUN apk add --no-cache \
    build-base \
    sqlite-dev \
    sqlite \
    nodejs \
    npm \
    tzdata \
    git

# Set working directory
WORKDIR /app

# Install gems
COPY Gemfile Gemfile.lock ./
RUN bundle config set --local without 'development test' && \
    bundle install --jobs 4 --retry 3

# Install Node.js dependencies
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

# Copy application code
COPY . .

# Precompile assets
ENV RAILS_ENV=production
ENV RAILS_SERVE_STATIC_FILES=true
ENV RAILS_LOG_TO_STDOUT=true

RUN bundle exec rails assets:precompile

# Production stage
FROM ruby:3.4.5-alpine AS production

# Install runtime dependencies
RUN apk add --no-cache \
    sqlite-dev \
    sqlite \
    tzdata \
    nodejs

# Create app user
RUN addgroup -g 1000 -S app && \
    adduser -u 1000 -S app -G app

# Set working directory
WORKDIR /app

# Copy gems from base stage
COPY --from=base /usr/local/bundle /usr/local/bundle

# Copy application code
COPY --from=base /app /app

# Copy precompiled assets
COPY --from=base /app/public/assets /app/public/assets
COPY --from=base /app/public/packs /app/public/packs

# Set ownership
RUN chown -R app:app /app

# Switch to app user
USER app

# Expose port
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:3000/health || exit 1

# Start the application
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
