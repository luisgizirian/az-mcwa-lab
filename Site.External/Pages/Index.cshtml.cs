using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Text.Json;
using System.Threading.Tasks;
using Common.Lib;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.Extensions.Caching.Distributed;
using Microsoft.Extensions.Logging;

namespace Site.External.Pages
{
    public class IndexModel : PageModel
    {
        private readonly ILogger<IndexModel> _logger;
        private readonly IHttpClientFactory _httpFactory;
        private readonly IDistributedCache _cache;

        public IEnumerable<WeatherForecast> Result { get; set; }

        public IndexModel(
            ILogger<IndexModel> logger,
            IHttpClientFactory httpFactory,
            IDistributedCache cache)
        {
            _logger = logger;
            _httpFactory = httpFactory;
            _cache = cache;
        }

        private HttpClient Client
        {
            get => _httpFactory.CreateClient(Constants.API);
        }

        public async Task OnGet()
        {
            var raw = await _cache.GetStringAsync(Constants.CACHE_KEY);

            if (!string.IsNullOrEmpty(raw))
            {
                Result = JsonSerializer.Deserialize<IEnumerable<WeatherForecast>>(
                    raw);
            }
            else
            {
                Result = await GetFromPersistentStorage();
                await _cache.SetStringAsync(Constants.CACHE_KEY, JsonSerializer.Serialize(Result));
            }

            
        }

        private async Task<IEnumerable<WeatherForecast>> GetFromPersistentStorage()
        {
            var resp = await this.Client.GetAsync($"api/weatherforecast");
            
            resp.EnsureSuccessStatusCode();

            var original = JsonSerializer.Deserialize<IEnumerable<WeatherForecast>>(
                await resp.Content.ReadAsStringAsync());

            return original;
            //
        }
    }
}

