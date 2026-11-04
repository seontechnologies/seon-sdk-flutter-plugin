package io.seon.seon_sdk_flutter_plugin

import android.content.Context
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.seon.androidsdk.dto.SeonGeolocationConfig
import io.seon.androidsdk.service.Seon
import io.seon.androidsdk.service.SeonBuilder
import kotlin.test.AfterTest
import kotlin.test.BeforeTest
import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertTrue
import org.mockito.ArgumentCaptor
import org.mockito.MockedConstruction
import org.mockito.Mockito
import org.mockito.stubbing.Answer

internal class SeonSdkFlutterPluginTest {
  private lateinit var seon: Seon
  private lateinit var builders: MockedConstruction<SeonBuilder>
  private lateinit var plugin: SeonSdkFlutterPlugin

  @BeforeTest
  fun setUp() {
    seon = Mockito.mock(Seon::class.java)
    val fluentAnswer = Answer<Any?> { invocation ->
      val returnType = invocation.method.returnType
      when {
        returnType == Seon::class.java -> seon
        returnType.isInstance(invocation.mock) -> invocation.mock
        else -> null
      }
    }
    builders = Mockito.mockConstruction(
      SeonBuilder::class.java,
      Mockito.withSettings().defaultAnswer(fluentAnswer)
    )

    val binding = Mockito.mock(FlutterPlugin.FlutterPluginBinding::class.java)
    Mockito.`when`(binding.binaryMessenger).thenReturn(Mockito.mock(BinaryMessenger::class.java))
    Mockito.`when`(binding.applicationContext).thenReturn(Mockito.mock(Context::class.java))
    plugin = SeonSdkFlutterPlugin()
    plugin.onAttachedToEngine(binding)
  }

  @AfterTest
  fun tearDown() {
    builders.close()
  }

  private fun invoke(method: String, args: Map<String, Any?>? = null) {
    plugin.onMethodCall(MethodCall(method, args), Mockito.mock(MethodChannel.Result::class.java))
  }

  private fun lastBuilder(): SeonBuilder = builders.constructed().last()

  private fun geoConfigArgs() = mapOf(
    "geolocationServiceTimeoutMs" to 4000,
    "maxGeoLocationCacheAgeSec" to 100,
    "prefetchEnabled" to false,
    "geolocationEnabled" to true
  )

  @Test
  fun dnsTimeoutThenSsid_lastRebuildKeepsBoth() {
    invoke("setDnsTimeout", mapOf("timeoutInMillisec" to 3000))
    invoke("setOpportunisticSsidCollectionEnabled", mapOf("enabled" to true))

    Mockito.verify(lastBuilder()).withDnsTimeout(3000)
    Mockito.verify(lastBuilder()).withOpportunisticSsidCollectionEnabled(true)
  }

  @Test
  fun ssidThenDnsTimeout_lastRebuildKeepsBoth() {
    invoke("setOpportunisticSsidCollectionEnabled", mapOf("enabled" to true))
    invoke("setDnsTimeout", mapOf("timeoutInMillisec" to 3000))

    Mockito.verify(lastBuilder()).withDnsTimeout(3000)
    Mockito.verify(lastBuilder()).withOpportunisticSsidCollectionEnabled(true)
  }

  @Test
  fun dnsTimeoutUpdatedTwice_usesLatestValueAndKeepsSsid() {
    invoke("setOpportunisticSsidCollectionEnabled", mapOf("enabled" to true))
    invoke("setDnsTimeout", mapOf("timeoutInMillisec" to 3000))
    invoke("setDnsTimeout", mapOf("timeoutInMillisec" to 5000))

    Mockito.verify(lastBuilder()).withDnsTimeout(5000)
    Mockito.verify(lastBuilder(), Mockito.never()).withDnsTimeout(3000)
    Mockito.verify(lastBuilder()).withOpportunisticSsidCollectionEnabled(true)
  }

  @Test
  fun ssidDisabledAfterEnabled_usesLatestValueAndKeepsDnsTimeout() {
    invoke("setDnsTimeout", mapOf("timeoutInMillisec" to 3000))
    invoke("setOpportunisticSsidCollectionEnabled", mapOf("enabled" to true))
    invoke("setOpportunisticSsidCollectionEnabled", mapOf("enabled" to false))

    Mockito.verify(lastBuilder()).withOpportunisticSsidCollectionEnabled(false)
    Mockito.verify(lastBuilder(), Mockito.never()).withOpportunisticSsidCollectionEnabled(true)
    Mockito.verify(lastBuilder()).withDnsTimeout(3000)
  }

  @Test
  fun onlyDnsTimeoutSet_ssidIsNotConfigured() {
    invoke("setDnsTimeout", mapOf("timeoutInMillisec" to 3000))

    Mockito.verify(lastBuilder()).withDnsTimeout(3000)
    Mockito.verify(lastBuilder(), Mockito.never())
      .withOpportunisticSsidCollectionEnabled(Mockito.anyBoolean())
  }

  @Test
  fun onlySsidSet_dnsTimeoutIsNotConfigured() {
    invoke("setOpportunisticSsidCollectionEnabled", mapOf("enabled" to true))

    Mockito.verify(lastBuilder()).withOpportunisticSsidCollectionEnabled(true)
    Mockito.verify(lastBuilder(), Mockito.never()).withDnsTimeout(Mockito.anyInt())
  }

  @Test
  fun geolocationConfigSetBeforeRebuild_isPassedToRebuiltSeon() {
    invoke("setGeolocationConfig", geoConfigArgs())
    invoke("setDnsTimeout", mapOf("timeoutInMillisec" to 3000))
    invoke("setOpportunisticSsidCollectionEnabled", mapOf("enabled" to true))

    val captor = ArgumentCaptor.forClass(SeonGeolocationConfig::class.java)
    Mockito.verify(lastBuilder()).withGeoLocationConfig(captor.capture())
    assertEquals(4000, captor.value.geolocationServiceTimeoutMs)
    assertTrue(captor.value.isGeolocationEnabled())
  }

  @Test
  fun geolocationConfigSetAfterRebuild_doesNotDropDnsTimeoutOrSsid() {
    invoke("setDnsTimeout", mapOf("timeoutInMillisec" to 3000))
    invoke("setOpportunisticSsidCollectionEnabled", mapOf("enabled" to true))
    val buildersBefore = builders.constructed().size
    invoke("setGeolocationConfig", geoConfigArgs())
    invoke("setOpportunisticSsidCollectionEnabled", mapOf("enabled" to true))

    assertTrue(builders.constructed().size > buildersBefore)
    Mockito.verify(lastBuilder()).withDnsTimeout(3000)
    Mockito.verify(lastBuilder()).withOpportunisticSsidCollectionEnabled(true)
    val captor = ArgumentCaptor.forClass(SeonGeolocationConfig::class.java)
    Mockito.verify(lastBuilder()).withGeoLocationConfig(captor.capture())
    assertEquals(4000, captor.value.geolocationServiceTimeoutMs)
  }

  @Test
  fun sessionIdSetByFingerprintCall_survivesRebuild() {
    invoke("getFingerprint", mapOf("sessionId" to "session-1"))
    invoke("setDnsTimeout", mapOf("timeoutInMillisec" to 3000))
    invoke("setOpportunisticSsidCollectionEnabled", mapOf("enabled" to true))

    Mockito.verify(lastBuilder()).withSessionId("session-1")
  }
}
