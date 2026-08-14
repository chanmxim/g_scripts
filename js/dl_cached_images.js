// =============================================================================
// The script to install cached images from a website, such as mangalib, TO DATE
// =============================================================================
//
// Retrieve all cache names
// await caches.keys()

// Specify the cache name
const cacheName = ""; // await caches.keys()[0]

(async function downloadCacheImages(cacheName) {
  // Check if cache exists
  if (!(await caches.has(cacheName))) {
    console.error(`Cache "${cacheName}" not found`);
    return;
  }

  const cache = await caches.open(cacheName);
  const requests = await cache.keys();

  for (let i = 0; i < requests.length; i++) {
    const request = requests[i];
    const response = await cache.match(request);

    if (!response) {
      continue;
    }

    // Retrieve image and create local url
    const blob = await response.blob();
    const contentType = response.headers.get("content-type") || "";
    const url = URL.createObjectURL(blob);

    // Extract a filename from the url or construct one if absent
    let filename = request.url.split("/").pop().split("?")[0];
    if (!filename || filename.length > 100) {
      filename = `image_${i + 1}`;
    }

    // Append extension if missing based on MIME type
    if (!filename.includes(".")) {
      const ext = contentType.split("/")[1]?.split("+")[0] || "jpg";
      filename += `.${ext}`;
    }

    // Trigger download
    const a = document.createElement("a");
    a.href = url;
    a.download = filename;
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(url);

    // Small delay to prevent browser download queue throttling
    await new Promise((resolve) => setTimeout(resolve, 150));
  }

  console.log(`Finished downloading files from ${cacheName}!`);
})(cacheName);
