

using PetsMobile.Repository.Interface;
using PetsMobile.Services.Interface;

namespace PetsMobile.Services
{
    public class RefreshTokenCleanupService : IHostedService, IDisposable
    {
        private readonly ILogger<RefreshTokenCleanupService> _logger;
        private readonly IServiceScopeFactory _scopeFactory;
        private Timer? _timer;

        public RefreshTokenCleanupService(ILogger<RefreshTokenCleanupService> logger, IServiceScopeFactory scopeFactory)
        {
            _logger = logger;
            _scopeFactory = scopeFactory;
        }

        public Task StartAsync(CancellationToken cancellationToken)
        {
            _logger.LogInformation("Refresh Token cleanup service started");
            _timer = new Timer(Cleanup, null, TimeSpan.Zero, TimeSpan.FromSeconds(10));
            return Task.CompletedTask;
        }

        private async void Cleanup(object? state)
        {
            using (IServiceScope scope = _scopeFactory.CreateScope())
            {
                IAuthService authService = scope.ServiceProvider.GetRequiredService<IAuthService>();

                long tokens = await authService.RemoveAllInactiveTokens();
                _logger.LogInformation($"Removed {tokens} inactive tokens");
            }
        }

        public Task StopAsync(CancellationToken cancellationToken)
        {
            _timer?.Change(Timeout.Infinite, 0);
            return Task.CompletedTask;
        }

        public void Dispose() 
        {
            _timer?.Dispose();
        }
    }
}
