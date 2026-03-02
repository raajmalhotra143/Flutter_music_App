$urls = @{
    "Music_Discovery_Home_Screen_1.png" = "https://lh3.googleusercontent.com/aida/AOfcidV5RriaqXa3LUQwDINmq91rRf3qECO50XV-9VNCVk9Gvs_mThoDkIqx-pt0r6SKF1ZliG2o-eL1StMun2_Cm4SlTg2oqv7pbPbgZDJzOkn7MjXQMv2CgoW1UJ8pdtuMsR7bdPA6Wi72UbndeNgQ4wGEPXng8dY8Gcn29MTejpJMdSvcZLsN8e6w4cIE4td-zmGXDL_nxBgQn6nJSirqRZa_ILjx3BFJfupv7UoBOzzgNaZ1DS56qJZN7Q"
    "Now_Playing_Screen_2.png" = "https://lh3.googleusercontent.com/aida/AOfcidWpcQhlJBZQGrvn813hVNoh9qViYNcMG1j12uV_gm5XSFHlf9hoIWv3lZ9IuxNVLewcUacNLC5qphkFucQycc5snH9DWuRaNhuYZ_DF0lfK1zix0XZPprGbXiWHE3Wx_9nfoB4sGo6ynZzHxXj8VWDZDq-a2RA2rfg8cjaIax3ec5HakPE9reBV1234oTriRwemdMkIXCKBSLGbdP8jOCMiu8mmlDcdBdWZrQqoHKpLdPRL-kapvc1MboI"
    "My_Music_Library_Screen_3.png" = "https://lh3.googleusercontent.com/aida/AOfcidVonCNB5i94nhHIkBU5xvh2MSAbMFfVW-nS01uxg_XKvXs8-ZqNgZEveg0CVO8Jn7t7BPPgG3CmQYOw52ZskO2LnEPBp8L54V8rWIqGYPdSiDepAgAcBMBeDYQWEpAwzr-yQpeGq-8biDHnPShu1P3lyYzhLOK9kdmZICTyYCbxGG-SqKYMKHXseC-oBGQhT2bB1FOKEacgpcpDgao9icOLIUFLLLAFn81IclDdVKSXcMTZU4yeWkL-Xw"
    "Music_Discovery_Home_Screen_4.png" = "https://lh3.googleusercontent.com/aida/AOfcidWy5zGEuQNGZSLgkNEqIGdUO4Pu_CmT6jDarIzoyLATv8SdwBCucbCrvBOvJnqwYy-C5cjy93Ch3Gxcu-AIcnwjORDXIACevJ6QEc1LydrFc_LWoUrcVeK-XqexrbRrC5-AtnfOObjbRiXYBaKjcNqqoFLTbcn6oER_JMioOQiaQ549TDTLq6J81AwmD8ULJZ_gH4Luu686s6HG9xsNzhpF4gDA_lfyW2A2qdbcwXd4LLNADihk7Yc2t_U"
    "Music_Discovery_Home_Screen_5.png" = "https://lh3.googleusercontent.com/aida/AOfcidWJ82ijwZQYOveJVhjAXaKuNycIt89TcBfrZnnnOrXB_rWevBA_vCCVz0t941_9IBSwOz6zPElIaS1Sy82BFPNGdCZemaQSRHobWV7XhuUjL1RYXyiq-hBxk0dxkWx-OH3D5rGzvNh-Un6OQ5Vne0TZKMdD8RwhPjL0Xs_1lzhPJGKQJEE5QENOSz-_MEjXr2Zz315ah5zJuODPv3F-_M_RyfCwxqLYZ9M9u4Zrzk4c1uQGm4P6YXRV1k4"
}

foreach ($item in $urls.GetEnumerator()) {
    $file = "Stitch_Screens\" + $item.Key
    $url = $item.Value
    Write-Host "Downloading $file..."
    curl.exe -L $url -o $file
}
Write-Host "Downloads complete."
